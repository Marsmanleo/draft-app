# draft-shell-integration (zprofile)
#
# See zshenv.zsh for the rationale on the trailing `:`.
{
  _draft_user_zdotdir="${DRAFT_USER_ZDOTDIR:-$HOME}"
  [ -f "$_draft_user_zdotdir/.zprofile" ] && source "$_draft_user_zdotdir/.zprofile"
  unset _draft_user_zdotdir
}
:
