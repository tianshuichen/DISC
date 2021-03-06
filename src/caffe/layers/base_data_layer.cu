#include <vector>

#include "caffe/data_layers.hpp"

namespace caffe {

template <typename Dtype>
void BasePrefetchingDataLayer<Dtype>::Forward_gpu(
    const vector<Blob<Dtype>*>& bottom, vector<Blob<Dtype>*>* top) {
  // First, join the thread
  JoinPrefetchThread();
  // Copy the data
  caffe_copy(prefetch_data_.count(), prefetch_data_.cpu_data(),
      (*top)[0]->mutable_gpu_data());
  if (this->output_labels_) {
    caffe_copy(prefetch_label_.count(), prefetch_label_.cpu_data(),
        (*top)[1]->mutable_gpu_data());
  }
  if (this->output_labels_alt_) {
		caffe_copy(prefetch_label_alt_.count(), prefetch_label_alt_.cpu_data(),
				(*top)[2]->mutable_cpu_data());
	}
	
	if (this->output_labels_alt1_) {
		caffe_copy(prefetch_label_alt1_.count(), prefetch_label_alt1_.cpu_data(),
				(*top)[3]->mutable_cpu_data());
	}
  // Start a new prefetch thread
  CreatePrefetchThread();
}

INSTANTIATE_CLASS(BasePrefetchingDataLayer);

}  // namespace caffe
