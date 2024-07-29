from typing import List, Optional

import torch
from torch.utils.data import DataLoader

from sssd_cp.data.dataset import ArDataset
from sssd_cp.data.utils import DataSplitter


class ArDataLoader:
    def __init__(
        self,
        coefficients: List[float],
        training_num_series: int,
        testing_num_series: int,
        series_length: int,
        std: float,
        intercept: float,
        season: int,
        batch_size: int,
        device: torch.device,
        num_workers: int,
        seeds: Optional[List[int]] = None,
    ) -> None:
        self.dataset = ArDataset(
            coefficients=coefficients,
            num_series=training_num_series + testing_num_series,
            series_length=series_length,
            std=std,
            season_period=season,
            intercept=intercept,
            seeds=seeds,
        )
        self.batch_size = batch_size
        self.device = device
        self.num_workers = num_workers
        self.generator = torch.Generator()
        self.generator.manual_seed(seeds[0] if seeds else 0)

        data_splitter = DataSplitter(training_num_series, self.generator)
        self.train_data, self.test_data = data_splitter.split(self.dataset)

    @property
    def train_dataloader(self) -> DataLoader:
        return DataLoader(
            self.train_data,
            shuffle=True,
            batch_size=self.batch_size,
            num_workers=self.num_workers,
        )

    @property
    def test_dataloader(self) -> DataLoader:
        return DataLoader(
            self.test_data,
            shuffle=False,
            batch_size=self.batch_size,
            num_workers=self.num_workers,
        )
