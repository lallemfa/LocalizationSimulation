import numpy as np
import sys
from scipy.interpolate import griddata
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm

if __name__ == '__main__':

    x_input = "C:/Code/Environment_data/area_1/gridX.txt"
    y_input = "C:/Code/Environment_data/area_1/gridY.txt"
    z_input = "C:/Code/Environment_data/area_1/gridZ.txt"
    output = "C:/Code/Environment_data/area_1/map.npz"
    
#	if len(sys.argv) != 5:
#		print("Need 4 argument but {} was given. Usage : python convertXYZ2NPZ.py path_to_x_file path_to_y_file path_to_z_file path_to_created_npz_file".format(len(sys.argv)))
#		sys.exit(1)

    xcloud = np.array([])
    ycloud = np.array([])
    zcloud = np.array([])

    with open(x_input, 'r') as xfile, open(y_input, 'r') as yfile, open(z_input, 'r') as zfile:
        for line in xfile:
            datas = line.split()
            datas = [float(i) for i in datas]
            xcloud = np.vstack((xcloud, datas)) if len(xcloud) else datas
    
        for line in yfile:
            datas = line.split()
            datas = [float(i) for i in datas]
            ycloud = np.vstack((ycloud, datas)) if len(ycloud) else datas
    
        for line in zfile:
            datas = line.split()
            datas = [float(i) for i in datas]
            zcloud = np.vstack((zcloud, datas)) if len(zcloud) else datas
    
        original_cloud = np.dstack([xcloud, ycloud, zcloud])
        
# =============================================================================
#     Interpolate to delete NaN
# =============================================================================
    

    pts = np.reshape(original_cloud, (1, -1, 3))[0, :, :]
    
    pts = pts[~np.isnan(pts[:, 2])]
    
    cloud = griddata(pts[:, 0:2], pts[:, 2], (xcloud, ycloud), method = "nearest")
    
    cloud = np.dstack((xcloud, ycloud, cloud))


#	np.savez(sys.argv[4], cloud)
    np.savez(output, cloud)