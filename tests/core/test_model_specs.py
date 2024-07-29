import pytest
import torch

from sssd_cp.core.model_specs import create_forecast_mask


@pytest.fixture
def sample_batch() -> torch.Tensor:
    # Create a sample batch of size (batch_size, sequence_length, feature_dim)
    batch_size = 4
    sequence_length = 10
    feature_dim = 1
    return torch.randn(batch_size, sequence_length, feature_dim)


def test_create_forecast_mask(sample_batch: torch.Tensor) -> None:
    unseen_length = 5
    device = torch.device("cpu")

    mask = create_forecast_mask(sample_batch, unseen_length, device)

    # Check the shape of the mask
    assert mask.shape == (sample_batch.size(0), 1, sample_batch.size(1))

    # Check the device of the mask
    assert mask.device == device

    # Check the dtype of the mask
    assert mask.dtype == torch.float32


if __name__ == "__main__":
    pytest.main()
