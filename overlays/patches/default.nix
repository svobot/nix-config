_: prev: {
  vimPlugins = prev.vimPlugins.extend (
    _: prevPlugins: {
      todo-comments-nvim = prevPlugins.todo-comments-nvim.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./0001-Highlight-in-documentation-comments.patch ];
      });
    }
  );
}
