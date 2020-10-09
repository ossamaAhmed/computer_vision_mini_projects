function main()
close all;
clear all;
clc;
load('../data/params.mat');
params.num_particles = 300;
params.hist_bin = 8;
params.model = 1;
params.alpha = 0;
params.sigma_velocity = 4;
params.initial_velocity = [10 ,0];
params.sigma_position = 25;
params.sigma_observe = 1.0;

condensationTracker('video3',params);
end