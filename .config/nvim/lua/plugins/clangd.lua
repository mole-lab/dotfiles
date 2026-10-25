-- Use clangd from the system `clang` package (pacman, signed) instead of Mason.
-- The package also brings clang, clang-tidy, clang-format and AddressSanitizer.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { mason = false },
      },
    },
  },
}
