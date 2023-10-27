require('gitblame').setup {
     --Note how the `gitblame_` prefix is omitted in `setup`
    enabled = false,
    date_format = '%r',
    message_template = "<author> • <date> • <summary>",
    highlight_group = "Question",
}
