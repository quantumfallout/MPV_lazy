### https://gist.github.com/hooke007/4f2e6f91d0a3f4a6515ee4e54fab375c

import vapoursynth as vs
from vapoursynth import core

input = video_in
colorlv = input.get_frame(0).props._ColorRange

denoise_lv = -1
scale_model = 2
GPU = 0
GPU_t = 2

cut1 = input.resize.Bilinear(format=vs.RGBS, matrix_in_s="709")
cut2 = core.rcnv.RealCUGAN(clip=cut1, scale=2, noise=denoise_lv, model=scale_model, syncgap=0, gpu_id=GPU, gpu_thread=GPU_t)
output = cut2.resize.Bilinear(format=vs.YUV444P16, matrix_s="709", range=1 if colorlv==0 else None)

output.set_output()
