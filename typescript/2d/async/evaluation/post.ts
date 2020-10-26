const postEvaluation = async (data: any) => {
  try {
    const response = await fetch('https://r2vr.herokuapp.com/evaluation', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (![200, 201].includes(response.status)) {
      throw new Error('Unable to post annotation!');
    }
    document.getElementById('postPlane')!.setAttribute('color', 'green');
    console.log('Request complete! response:', response, response.status);
  } catch (err) {
    throw new Error(`${err} - Unable to post annotation!`);
  }
};

export default postEvaluation;
