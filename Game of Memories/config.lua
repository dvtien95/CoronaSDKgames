--
-- Tien Dinh --
--

local targetDevice = ( system.getInfo( "model" ) )

if targetDevice == "iPad" or "android" then
  application = 
    {
    content = 
    {
      width = 320,
      height = 480,
      scale = "zoomStretch",
      fps = 60,
      imageSuffix = 
          {
            ["@2x"] = 2,
            ["@4x"] = 4,
          },
      },
    }
else
  application =
  {
    content =
    {
      width = 320,
      height = 480, 
      scale = "letterBox",
      fps = 60,
      imageSuffix =
      {
          ["@2x"] = 2,
          ["@4x"] = 4,
      },
    },
  }
end
