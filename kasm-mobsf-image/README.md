# MobSF Workspace Image
This repository contains the necessary components to build a Kasm Workspace image with Docker pre-installed. When a new session is created, the workspace pulls the latest MobSF image, launches a MobSF container, and opens it in the Chromium web browser. Administrators may leverage this image directly or use it as a starting point for their own custom images. 

This image is based off of the Debian Bookworm [**Workspaces Core Image**](https://github.com/kasmtech/workspaces-core-images) which contains the necessary wiring to work within the Kasm Workspaces platform. This image also pulls components and inspiration from [**Kasm Default Images**](https://github.com/kasmtech/workspace-images), including [Chromium](https://github.com/kasmtech/workspaces-images/blob/78378e94d92595d18892a2a69ef25a284d8b2ea7/dockerfile-kasm-chromium) and [Spiderfoot](https://github.com/kasmtech/workspaces-images/blob/78378e94d92595d18892a2a69ef25a284d8b2ea7/src/ubuntu/install/spiderfoot/custom_startup.sh).

For more information about building custom images please review Kasm's  [**How To Guide**](https://kasmweb.com/docs/latest/how_to/building_images.html). The Kasm team publishes applications and desktop images for use inside their platform. More information, including source can be found in Kasm's [**Default Images List**](https://kasmweb.com/docs/latest/guide/custom_images.html).

# Manual Deployment
To build the provided image:

    sudo docker build -t kasm-mobsf:1.17.0 -f dockerfile-kasm-mobsf .

This image requires leveraging the Sysbox runtime by setting the `Docker Run Config Override (JSON)`

```json
{
  "runtime": "sysbox-runc",
  "entrypoint": [
    "/sbin/init"
  ],
  "user": 0
}
```

While this image is primarily built to run inside the Workspaces platform, it can also be executed manually.  Please note that certain functionality, such as audio, uploads, downloads, and microphone pass-through are only available within the Kasm platform.

    sudo docker run --rm  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasm-mobsf:1.17.0

The container is now accessible via a browser : `https://<IP>:6901`

 - **User** : `kasm_user`
 - **Password**: `password`
