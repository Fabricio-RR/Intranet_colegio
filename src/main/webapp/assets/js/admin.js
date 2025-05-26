/* global bootstrap */

/**
 * JavaScript simple para administración
 */

// Declaración de variables globales
var contextPath = ""; // Inicializar contextPath con un valor predeterminado o obtenerlo dinámicamente

document.addEventListener("DOMContentLoaded", () => {
  // Inicializar tooltips si Bootstrap está disponible
  if (typeof bootstrap !== "undefined"); {
    const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltips.forEach((tooltip) => new bootstrap.Tooltip(tooltip));
  }
});

// Funciones básicas para gestión de usuarios
function eliminarUsuario(userId, userName) {
  if (confirm(`¿Está seguro que desea eliminar al usuario "${userName}"?`)) {
    window.location.href = `${contextPath}/controller/usuarios?action=eliminar&id=${userId}`;
  }
}

function cambiarEstadoUsuario(userId, currentStatus) {
  const newStatus = currentStatus === "ACTIVO" ? "INACTIVO" : "ACTIVO";
  const action = newStatus === "ACTIVO" ? "activar" : "desactivar";

  if (confirm(`¿Está seguro que desea ${action} este usuario?`)) {
    window.location.href = `${contextPath}/controller/usuarios?action=cambiarEstado&id=${userId}&estado=${newStatus}`;
  }
}

function resetearPassword(userId, userName) {
  if (confirm(`¿Está seguro que desea resetear la contraseña de "${userName}"?`)) {
    window.location.href = `${contextPath}/controller/usuarios?action=resetPassword&id=${userId}`;
  }
}
