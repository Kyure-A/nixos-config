final: prev: {
  brewCasks = prev.brewCasks // {
    alcove = prev.brewCasks.alcove.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = if oldAttrs.src ? urls then prev.lib.lists.head oldAttrs.src.urls else oldAttrs.src.url;
        hash = "sha256-erZDj7Z3vQq57kH5+eNkG5q/Z9nb1ILkw17GePIOg30=";
      };
    });
  };
}
