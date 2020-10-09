function [particles, particles_w] = resample(particles,particles_w)
n = size(particles,1);
idicies = randsample(n,n,true,particles_w);
particles = particles(idicies,:);
particles_w = particles_w(idicies);
particles_w(:) = particles_w(:)./ sum(particles_w);
end