from run_model import run_model
import numpy as np

velocities = ['slow', 'med', 'fast']
frictions = ['high', 'med', 'low']

# velocity = "slow"
# friction = "low"

collider_dict = {
    'slow_high': [1, 2, 3, 4, 6, 13],
    'slow_med': [1, 2, 3, 4, 5, 7, 10],
    'slow_low': [1, 2, 3, 4, 5, 7, 12],
    'med_high': [1, 3, 5, 6, 7, 8, 10, 13],
    'med_med': [1, 4, 6, 7, 8, 9, 11, 14],
    'med_low': [2, 5, 7, 8, 9, 10, 12, 16],
    'fast_high': [4, 8, 10, 11, 12, 13, 15, 17],
    'fast_med': [6, 11, 13, 14, 15, 16, 17],
    'fast_low': [5, 12, 14, 15, 16, 17]
}

# collider_dict = {
#     'slow_high': [2, 3],
#     'slow_med': [3, 4],
#     'slow_low': [3, 4],
#     'med_high': [6, 7],
#     'med_med': [7, 8],
#     'med_low': [8, 9],
#     'fast_high': [11, 12],
#     'fast_med': [14, 15],
#     'fast_low': [15, 16]
# }

# colors = ["teal", "pink", "purple", "tan"]
color = "teal"

# v = 'fast'
# f = 'low'

for v in velocities:
    for f in frictions:
        fr_noise = 0.1
        vel_noise = 0.05
        col_noise = 0.15
        vf_str = '{}_{}'.format(v,f)
        cps = collider_dict[vf_str]
        data_dict = {}
        for col_pos in cps:
            res = []
            for i in range(30):
                c = run_model(f, v, color, col_pos, fr_noise, vel_noise, col_noise)
                res.append(c)
            data_dict[col_pos] = res

        np.save('model_data/model3/{}_fr{}_vel{}_col{}.npy'.format(vf_str, fr_noise, vel_noise, col_noise), data_dict)