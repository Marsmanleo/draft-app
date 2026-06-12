import type { Theme } from "../types";

export const draftDefault: Theme = {
  id: "draft-default",
  name: "Draft Default",
  description: "The default Draft look — clean glass over neutral surfaces.",
  editorTheme: { dark: "atomone", light: "atomone" },
  variants: {
    light: {},
    dark: {},
  },
};
