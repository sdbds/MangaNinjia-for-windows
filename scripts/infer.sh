#!/usr/bin/env bash
set -e
set -x
pretrained_model_name_or_path='./checkpoints/StableDiffusion'
image_encoder_path='./checkpoints/models/clip-vit-large-patch14'
controlnet_model_name_or_path='./checkpoints/models/control_v11p_sd15_lineart'
annotator_ckpts_path='./checkpoints/models/Annotators'

manga_reference_unet_path='./checkpoints/MangaNinjia/reference_unet.pth'
manga_main_model_path='./checkpoints/MangaNinjia/denoising_unet.pth'
manga_controlnet_model_path='./checkpoints/MangaNinjia/controlnet.pth'
point_net_path='./checkpoints/MangaNinjia/point_net.pth'
export CUDA_VISIBLE_DEVICES=0

input_reference_paths='./test_cases/hz0.png ./test_cases/hz1.png'
input_lineart_paths='./test_cases/hz1.png ./test_cases/hz0.png'
point_ref_paths='./test_cases/hz01_0.npy ./test_cases/hz01_1.npy'
point_lineart_paths='./test_cases/hz01_1.npy ./test_cases/hz01_0.npy'
cd ..
python infer.py  \
    --seed 0 \
    --denoise_steps 50 \
    --pretrained_model_name_or_path $pretrained_model_name_or_path --image_encoder_path $image_encoder_path \
    --controlnet_model_name_or_path $controlnet_model_name_or_path --annotator_ckpts_path $annotator_ckpts_path \
    --manga_reference_unet_path $manga_reference_unet_path --manga_main_model_path $manga_main_model_path \
    --manga_controlnet_model_path $manga_controlnet_model_path --point_net_path $point_net_path \
    --output_dir 'output' \
    --guidance_scale_ref 9 \
    --guidance_scale_point 15 \
    --input_reference_paths $input_reference_paths \
    --input_lineart_paths $input_lineart_paths \
    --point_ref_paths $point_ref_paths \
    --point_lineart_paths $point_lineart_paths \
