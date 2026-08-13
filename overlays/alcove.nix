final: prev: {
  brewCasks = prev.brewCasks // {
    alcove = prev.brewCasks.alcove.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = if oldAttrs.src ? urls then prev.lib.lists.head oldAttrs.src.urls else oldAttrs.src.url;
        hash = "sha256-F8SB/6mvkfx24rqZlflnUFOL8XHl6yvmAsByVfTZROU=";
      };
    });
  };
}
