### https://gist.github.com/hooke007/ce3e04b549f48103d15dfe3e21c364b0

import vapoursynth as vs
from vapoursynth import core

input = video_in
colorlv = input.get_frame(0).props._ColorRange

denoise_lv = -1
scale_model = 2
GPU = 0
GPU_t = 2

cut1 = input.resize.Bilinear(format=vs.RGBS, matrix_in_s="709")
cut2 = core.w2xncnnvk.Waifu2x(clip=cut1, noise=denoise_lv, scale=2, model=scale_model, gpu_id=GPU, gpu_thread=GPU_t)
output = cut2.resize.Bilinear(format=vs.YUV444P16, matrix_s="709", range=1 if colorlv==0 else None)

output.set_output()
