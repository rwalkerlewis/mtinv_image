# Define variables for convenience
$ImageName = "mtinvimage"
$LocalDir = "C:\Users\rober\Projects\mtinv_image_data"
$ContainerDir = "/home/mtinv-user"
$DisplayHost = "host.docker.internal:0.0"

# Run the Docker container
docker run -it `
    -e DISPLAY=$DisplayHost `
    -v "${LocalDir}:${ContainerDir}" `
    -v /tmp/.X11-unix:/tmp/.X11-unix `
    --network host `
    $ImageName