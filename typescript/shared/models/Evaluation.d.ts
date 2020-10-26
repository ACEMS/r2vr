declare namespace Shared {
  export type QuestionResponseOption = 1 | 2 | 3 | 4;
  export type QuestionResponse = {
    questionNumber: number;
    selectedOption: QuestionResponseOption;
  };

  export interface EvaluationResponse {
    isCurrentOptionSelected: boolean;
    isCurrentOptionSubmitted: boolean;
    evaluations: QuestionResponse[];
  }
}
