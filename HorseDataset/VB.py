# Variational Bayes #

import os
import numpy as np
import pandas as pd
import cmdstanpy
from cmdstanpy.model import CmdStanModel
from cmdstanpy.utils import cmdstan_path

output_directory = r"/O11"
directory_path = r"/s1"

file_names = os.listdir(directory_path)

file_paths = []
for file_name in file_names:
    file_path = os.path.join(directory_path, file_name)
    file_paths.append(file_path)

first = file_paths[:500]
second = file_paths[500:]

model_dir = r'/data'
stan_file = os.path.join(model_dir, 'Model.stan')
model = CmdStanModel(stan_file=stan_file)

for iteration in range(len(second)):
    data_file = first[iteration]
    try:
        vi = model.variational(data=data_file, grad_samples = 20)
    except RuntimeError as e:
        print(f"Error occurred in iteration {iteration + 1}: {e}")
        continue  # Skip to the next iteration

    a = vi.stan_variable("s2_e")
    b = vi.stan_variable("s2_h")
    c = vi.stan_variable("trt_eff")

    c1, c2 = c

    # Saving a, b, and c to a DataFrame
    df = pd.DataFrame({'a': [a], 'b': [b], 'c1': [c1], 'c2': [c2]})

    # Constructing file path for DataFrame
    file_name = f"iteration_{iteration + 1}.csv"
    file_path = os.path.join(output_directory, file_name)

    # Saving DataFrame to CSV
    df.to_csv(file_path, index=False)
    d = vi.stan_variable("horse_eff")
    e = vi.stan_variable("horse_probs")

    # Constructing file paths for d and e arrays
    d_file_path = os.path.join(output_directory, f"horse_eff_{iteration + 1}.csv")
    e_file_path = os.path.join(output_directory, f"horse_probs_{iteration + 1}.csv")

    # Saving d and e arrays to CSV
    np.savetxt(d_file_path, d, delimiter=",")
    np.savetxt(e_file_path, e, delimiter=",")
