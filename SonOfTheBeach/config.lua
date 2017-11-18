local targetDevice = ( system.getInfo( "model" ) )

if targetDevice == "iPad" or "android" then
  application = 
    {
    content = 
    {
      width = 360,
      height = 480,
      scale = "zoomEven",
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
      height = 480, 
      scale = "zoomEven",
      fps = 60,
      imageSuffix =
      {
            ["@2x"] = 2,
      },
    },
  }
end
