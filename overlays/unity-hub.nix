final: prev: {
  brewCasks = prev.brewCasks // {
    unity-hub = prev.brewCasks.unity-hub.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = if oldAttrs.src ? urls then prev.lib.lists.head oldAttrs.src.urls else oldAttrs.src.url;
        hash = "sha256-GHaj1u5DHtGfbTuTtbgzUQB3pSGhJEeMsCo9VgvZvGc=";
      };
    });
  };
}
