# How to create cabal x servant project

- mkdir "project-name"
- cd "project-name"
- cabal init
- open "project-name.cabal"
- add minimal required packages:  base, servant-server, aeson, wai, warp
  

  ![image](https://user-images.githubusercontent.com/58640322/203371050-241e1479-9cf2-4d63-aa89-2301ab70961c.png)
  
  
 ## Build app
 ```bash
 cabal build
 ```
## Run app
```bash
cabal run project-name
```
It will listen on port you specified in main 

![image](https://user-images.githubusercontent.com/58640322/203371981-2c79af85-051f-4a0c-9f1c-7a571460adc1.png)
