# Nifty terminal tools using [Gum](https://github.com/charmbracelet/gum) and [FZF](https://github.com/junegunn/fzf)

Technically the functionality of fzf is also provided by gum through `gum filter` but hey, this repo is about me exploring new tools and sometimes you've gotta try other things.

Will update this repo as I make more tools

change conda environment use:

	`source change-conda-env.sh`

Have to use source otherwise it launches in a sub-shell where conda is not configured 

add alias to .zshrc

	`alias ce="source /Users/pierre/Useful-Scripts/change-conda-env.sh"`

select and kill running process

	`alias kill-task="/path/to/search-and-kill-task.sh"`

the s3-file-manager script might grow into a larger project, navigating s3 object stores this way is pretty pleasant


what I have in my .zshrc
```bash
export CUSTOM_UTIL_PATH="~/Custom-Utilities"
alias ce="source ${CUSTOM_UTIL_PATH}/change-conda-env.sh"
alias kill-task="${CUSTOM_UTIL_PATH}/search-and-kill-task.sh"
alias cb="${CUSTOM_UTIL_PATH}/git-branch-switcher.sh"
```
