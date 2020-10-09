function new_particles = propagate(particles,sizeFrame,params)
if params.model==1
    A = [[1,0]',[0,1]',[1,0]',[0,1]']; % constant velocity
else
    A = [1 0;0 1]; % just noise
end
new_particles = zeros(size(particles));
i = 1;
%Start with the sample set of the previous step, 
%and apply the system model to each sample, 
%yielding predicted samples
while i <= params.num_particles
    %update all particle positions now using the system model and noise
    noise_position = normrnd(0,params.sigma_position,[1 2]);
    new_particles(i,1:2) = round((A * particles(i,:)')' + noise_position);
    %check if its in the frame or the particle got outside
    if (new_particles(i,1) > 0 && new_particles(i,1) <= sizeFrame(2)) && ...
       (new_particles(i,2) > 0 && new_particles(i,2) <= sizeFrame(1))
        %add the velocity paramater noise
        if (params.model==1) % not sure about this
            noise_velocity = normrnd(0,params.sigma_velocity,[1 2]);
            new_particles(i,3:4) = params.initial_velocity + noise_velocity;
        end
        %go to the next particle 
        i = i + 1;
    end
end
end