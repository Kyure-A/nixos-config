final: prev: {
  brewCasks = prev.brewCasks // {
    spotify = prev.brewCasks.spotify.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = if oldAttrs.src ? urls then prev.lib.lists.head oldAttrs.src.urls else oldAttrs.src.url;
        hash = "sha256-BhnTZyQ0bcSC0QQZmYZkzmuqNcnAolfpew/mlVhLJxk=";
      };
    });
  };
}
