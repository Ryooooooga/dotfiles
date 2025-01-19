import {
  ComplexModifications,
  complexModifications as complexModifications_,
  Rule,
  RuleBuilder,
} from "./deps.ts";

const parameters = {
  "basic.to_if_alone_timeout_milliseconds": 250,
  "basic.to_if_held_down_threshold_milliseconds": 250,
};

export function complexModifications(
  rules: Array<Rule | RuleBuilder>,
): ComplexModifications {
  return {
    ...complexModifications_(rules),
    parameters,
  };
}
