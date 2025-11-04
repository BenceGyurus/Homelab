sudo docker volume create clam_db && 
sudo docker run -d -it --rm \
    --name "clam_container_02" \
    --mount source=clam_db,target=/var/lib/clamav \
    --env 'CLAMAV_NO_FRESHCLAMD=true' \
    clamav/clamav:1.4_base