# MangaNinja: Line Art Colorization with Precise Reference Following

This repository represents the official implementation of the paper titled "MangaNinja: Line Art Colorization with Precise Reference Following".

[![Website](docs/badge-website.svg)](https://johanan528.github.io/MangaNinjia/)
[![Paper](https://img.shields.io/badge/arXiv-PDF-b31b1b)](https://arxiv.org/abs/2501.08332)
[![License](https://img.shields.io/badge/License-CC%20BY--NC%204.0-929292)](https://creativecommons.org/licenses/by-nc/4.0/)
<a href="https://huggingface.co/spaces/fffiloni/MangaNinja-demo"><img src="https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Spaces-blue)"></a>



<p align="center">
    <a href="https://johanan528.github.io/"><strong>Zhiheng Liu*</strong></a>
    ·
    <a href="https://felixcheng97.github.io/"><strong>Ka Leong Cheng*</strong></a>
    ·
    <a href="https://xavierchen34.github.io/"><strong>Xi Chen</strong></a>
    ·
    <a href="https://jiexiaou.github.io/"><strong>Jie Xiao</strong></a>
    ·
    <a href="https://ken-ouyang.github.io/"><strong>Hao Ouyang</strong></a>
    ·
    <a href="https://scholar.google.com/citations?user=Mo_2YsgAAAAJ&hl=zh-CN"><strong>Kai Zhu</strong></a>
    ·
    <a href="https://scholar.google.com/citations?user=8zksQb4AAAAJ&hl=zh-CN"><strong>Yu Liu</strong></a>
    ·
    <a href="https://shenyujun.github.io/"><strong>Yujun Shen</strong></a>
    ·
    <a href="https://cqf.io/"><strong>Qifeng Chen</strong></a>
    ·
    <a href="http://luoping.me/"><strong>Ping Luo</strong></a>
    <br>
  </p>

We propose **MangaNinja**, a reference-based line art colorization method. MangaNinja
automatically aligns the reference with the line art for colorization, demonstrating remarkable consistency. Additionally, users can achieve
more complex tasks using point control. We hope that MangaNinja can accelerate the colorization process in the anime industry.

![teaser](docs/teaser.gif)
## 📢 News
* 2025-01-20: 🔥 MangaNinja is available on huggingface space, Thanks [Sylvain Filoni](https://x.com/fffiloni) ! You can find it [here](https://huggingface.co/spaces/fffiloni/MangaNinja-demo).
* 2025-01-16: 🔥 MangaNinja is available on windows, 6G VRAM need Auto install and Download Model. Thanks [sdbds](https://x.com/bdsqlsz) ! You can find it [here](https://github.com/sdbds/MangaNinjia-for-windows). 
* 2025-01-15: Inference code and paper are released.
* 🏃: We will open an issue area to investigate user needs and adjust the model accordingly. This includes more memory-efficient structures, data formats for line art (such as binary line art), and considering retraining MangaNinjia on a better foundation model (sd3,flux).

## 🛠️ Setup

### 📦 Repository

Clone the repository (requires git):

```bash
git clone https://github.com/ali-vilab/MangaNinjia.git
cd MangaNinjia
```

### 💻 Dependencies

Install with `conda`: 
```bash
conda env create -f environment.yaml
conda activate MangaNinjia
```
### ⚙️ Weights
* You could download them from HuggingFace: [StableDiffusion](https://modelscope.cn/models/AI-ModelScope/stable-diffusion-v1-5), [clip-vit-large-patch14](https://huggingface.co/openai/clip-vit-large-patch14), [control_v11p_sd15_lineart](https://huggingface.co/lllyasviel/control_v11p_sd15_lineart) and [Annotators](https://huggingface.co/lllyasviel/Annotators/blob/main/sk_model.pth)
* You could download our [MangaNinjia model](https://huggingface.co/Johanan0528/MangaNinjia) from HuggingFace 
* The downloaded checkpoint directory should have the following structure:
```
-- checkpoints
    |-- StableDiffusion
    |-- models
        |-- clip-vit-large-patch14
        |-- control_v11p_sd15_lineart
        |-- Annotators
            |--sk_model.pth
    |-- MangaNinjia
        |-- denoising_unet.pth
        |-- reference_unet.pth
        |-- point_net.pth
        |-- controlnet.pth
```


## 🎮 Inference 
```bash
cd scripts
bash infer.sh
```

You can find all results in `output/`. Enjoy!

#### 📍 Inference settings

The default settings are optimized for the best result. However, the behavior of the code can be customized:
  - `--denoise_steps`: Number of denoising steps of each inference pass. For the original (DDIM) version, it's recommended to use 20-50 steps.
  - `--is_lineart`: If the user provides an image and the task is to color the line art within that image, this parameter is not needed. However, if the input is already a line art and no additional extraction is necessary, then this parameter should be included.
  - `--guidance_scale_ref`: Increasing makes the model more inclined to accept the guidance of the reference image.
  - `--guidance_scale_point`: Increasing makes the model more inclined to input point guidance to achieve more customized colorization.
  - `--point_ref_paths` and `--point_lineart_paths` (**optional**): Two 512x512 matrices are used to represent the matching points between the corresponding reference and line art with continuously increasing integers. That is, the coordinates of the matching points in both matrices will have the same values: 1, 2, 3, etc., while the values in other positions will be 0 (you can refer to the provided samples). Of course, we recommend using Gradio for point guidance.

## 🌱 Gradio
First, modify `./configs/inference.yaml` to set the path of model weights. Afterwards, run the script:
```bash
python run_gradio.py
```
The gradio demo would look like the UI shown below. 
<table align="center">
  <tr>
    <td>
      <img src="docs/gradio1.png" width="300" height="400">
    </td>
    <td>
      <img src="docs/gradio2.png" width="300" height="400">
    </td>
  </tr>
</table>
A biref tutorial:

1. Upload the reference image and target image. 

    Note that for the target image, there are two modes: you can upload an RGB image, and the model will automatically extract the line art; or you can directly upload the line art by checking the 'input is lineart' option. 

    The line art images are single-channel grayscale images, where the input consists of floating-point values with the background set to 0 and the line art close to 1. Additionally, we would like to further communicate with our users: if the line art you commonly use is binarized, please let us know. We will fine-tune the model and release an updated version to better suit your needs. 😆

2. Click 'Process Images' to resize the images to 512*512 resolution.
3. (Optional) **Starting from the reference image**, **alternately** click on the reference and target images in sequence to define matching points. Use 'Undo' to revert the last action.
4. Click 'Generate' to produce the result.
## 🌺 Acknowledgements
This project is developped on the codebase of [MagicAnimate](https://github.com/magic-research/magic-animate). We appreciate this great work! 

## 🎓 Citation

Please cite our paper:

```bibtex
@article{liu2025manganinja,
  title={MangaNinja: Line Art Colorization with Precise Reference Following},
  author={Liu, Zhiheng and Cheng, Ka Leong and Chen, Xi and Xiao, Jie and Ouyang, Hao and Zhu, Kai and Liu, Yu and Shen, Yujun and Chen, Qifeng and Luo, Ping},
  journal={arXiv preprint arXiv:2501.08332},
  year={2025}
}
```
