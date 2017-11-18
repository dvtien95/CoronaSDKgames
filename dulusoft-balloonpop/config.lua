local targetDevice = ( system.getInfo( "model" ) )

if targetDevice == "iPad" or "android" then
  application = 
    {
    content = 
    {
      width = 360,
      height = 640,
      scale = "zoomStretch",
      fps = 60,
      imageSuffix = 
          {
              ["@2x"] = 2,
          },
      },
    }
else
  application =
  {
    content =
    {
      width = 360,
      height = 640, 
      scale = "letterBox",
      fps = 60,
      imageSuffix =
      {
            ["@2x"] = 2,
      },
    },
  }
end
