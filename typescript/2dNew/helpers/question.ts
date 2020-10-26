import postAnnotations from '../http/postAnnotations';

export const questionObserver = () => {
  const mutationObserver = new MutationObserver(() => {
    postAnnotations();
    mutationObserver.disconnect();
  });

  mutationObserver.observe(document.getElementById('questionPlane')!, {
    attributes: true,
    attributeFilter: ['questioned'],
  });
};
