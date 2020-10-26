export type QuestionResponseOption = 1 | 2 | 3 | 4; // TODO: check if changed

export type QuestionResponse = {
  questionNumber: number;
  responseOption: QuestionResponseOption;
};

export interface EvaluationResponse {
  lastHoveredOption: number;
  questionNumber?: number;
  evaluations?: QuestionResponse[];
}
