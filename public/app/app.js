const input = document.getElementById('texto');
const boton = document.getElementById('mostrar');
const resultado = document.getElementById('resultado');

boton.addEventListener('click', () => {
  const texto = input.value.trim();
  resultado.textContent = texto ? texto : 'Por favor, escribe algo.';
});
