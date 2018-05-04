clc; clear all; close all;

load('Bedford2m_cleaned.mat');
load('Bedford2m_cleaned_latlong.mat');

Nrows       = size(Bathy, 1);
Ncolumns    = size(Bathy, 2);

Geo_WestEast    = [W:(E-W)/(Ncolumns-1):E];
Geo_SouthNorth  = [S:(N-S)/(Nrows-1):N];

UTM_WestEast    = [west:(east-west)/(Ncolumns-1):east];
UTM_SouthNorth  = [south:(north-south)/(Nrows-1):north];

[WE, SN] = meshgrid(UTM_WestEast, UTM_SouthNorth);

figure;
s = surf(WE, SN, Bathy);
s.EdgeColor = 'none';

Geo_WE = Geo_WestEast(1501:2000);
Geo_SN = Geo_SouthNorth(2601:3100);
UTM_WE = UTM_WestEast(1501:2000);
UTM_SN = UTM_SouthNorth(2601:3100);
depth  = Bathy(2601:3100, 1501:2000);
[mesh_UTM_WE, mesh_UTM_SN] = meshgrid(UTM_WE, UTM_SN);

figure;
s = surf(mesh_UTM_WE, mesh_UTM_SN, depth);
s.EdgeColor = 'none';

save('../reduced_bathy.mat', 'Geo_WE', 'Geo_SN', 'UTM_WE', 'UTM_SN', 'depth');

Geo_WE = Geo_WestEast(1701:1800);
Geo_SN = Geo_SouthNorth(2801:2900);
UTM_WE = UTM_WestEast(1701:1800);
UTM_SN = UTM_SouthNorth(2801:2900);
depth  = Bathy(2801:2900, 1701:1800);
[mesh_UTM_WE, mesh_UTM_SN] = meshgrid(UTM_WE, UTM_SN);

figure;
s = surf(mesh_UTM_WE, mesh_UTM_SN, depth);
s.EdgeColor = 'none';

save('../ICP_data_flat.mat', 'depth');

Geo_WE = Geo_WestEast(1801:1900);
Geo_SN = Geo_SouthNorth(2601:2700);
UTM_WE = UTM_WestEast(1801:1900);
UTM_SN = UTM_SouthNorth(2601:2700);
depth  = Bathy(2601:2700, 1801:1900);
[mesh_UTM_WE, mesh_UTM_SN] = meshgrid(UTM_WE, UTM_SN);

figure;
s = surf(mesh_UTM_WE, mesh_UTM_SN, depth);
s.EdgeColor = 'none';

save('../ICP_data_steep.mat', 'depth');

