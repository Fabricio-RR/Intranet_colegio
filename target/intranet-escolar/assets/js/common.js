/**
 * JavaScript común para toda la aplicación
 */

// Variables globales
window.IntranetApp = {
  contextPath: "",
  currentUser: null,
  config: {
    sessionTimeout: 30 * 60 * 1000, // 30 minutos
    autoSaveInterval: 60 * 1000, // 1 minuto
  },
}

// Inicialización cuando el DOM está listo
document.addEventListener("DOMContentLoaded", () => {
  initializeApp()
  initializeTooltips()
  initializeModals()
  initializeForms()
  initializeSidebar()
})

/**
 * Inicializa la aplicación
 */
function initializeApp() {
  // Obtener context path
  const scripts = document.getElementsByTagName("script")
  for (const script of scripts) {
    if (script.src && script.src.includes("/assets/js/common.js")) {
      const pathArray = script.src.split("/")
      const contextIndex = pathArray.findIndex((part) => part === "assets") - 1
      if (contextIndex >= 0) {
        window.IntranetApp.contextPath = "/" + pathArray[contextIndex]
      }
      break
    }
  }

  // Configurar CSRF token si existe
  const csrfToken = document.querySelector('meta[name="_csrf"]')
  if (csrfToken) {
    window.IntranetApp.csrfToken = csrfToken.getAttribute("content")
  }

  // Inicializar componentes
  initializeNavigation()
  initializeToggleSidebar()
}

/**
 * Inicializa el botón toggle del sidebar
 */
function initializeToggleSidebar() {
  // No hacer nada aquí, se maneja en initializeSidebar
}

/**
 * Inicializa el sidebar
 */
function initializeSidebar() {
  const toggleBtn = document.getElementById("sidebarToggle")
  const sidebar = document.getElementById("sidebar")
  const overlay = document.getElementById("sidebarOverlay")
  const sidebarLinks = document.querySelectorAll(".sidebar .nav-link")

  // Marcar enlace activo
  const currentPath = window.location.pathname
  sidebarLinks.forEach((link) => {
    link.classList.remove("active")

    if (link.getAttribute("href") === currentPath) {
      link.classList.add("active")

      // Si está dentro de un collapse, expandirlo
      const collapse = link.closest(".collapse")
      if (collapse) {
        collapse.classList.add("show")
        const toggleLink = document.querySelector(`[data-bs-target="#${collapse.id}"]`)
        if (toggleLink) {
          toggleLink.setAttribute("aria-expanded", "true")
          toggleLink.classList.remove("collapsed")
        }
      }
    }
  })

  // Función para cerrar sidebar
  function closeSidebar() {
    if (sidebar && overlay) {
      sidebar.classList.remove("show");
      overlay.classList.remove("show");
    }
  }

  // Función para abrir sidebar
  function openSidebar() {
    if (sidebar && overlay) {
      sidebar.classList.add("show")
      overlay.classList.add("show")
    }
  }

  // Toggle sidebar con botón hamburguesa
  if (toggleBtn) {
    toggleBtn.addEventListener("click", (e) => {
      e.preventDefault()
      e.stopPropagation()

      if (sidebar.classList.contains("show")) {
        closeSidebar()
      } else {
        openSidebar()
      }
    })
  }

  // Cerrar sidebar al hacer clic en overlay
  if (overlay) {
    overlay.addEventListener("click", (e) => {
      e.preventDefault()
      closeSidebar()
    })
  }

  // Cerrar sidebar al hacer clic en enlaces de navegación en móvil
  sidebarLinks.forEach((link) => {
    link.addEventListener("click", (e) => {
      // Solo cerrar en móvil y si es un enlace real (no dropdown/collapse)
      if (window.innerWidth <= 768) {
        const href = link.getAttribute("href")
        const hasToggle = link.hasAttribute("data-bs-toggle")
        const isDropdown = link.classList.contains("dropdown-toggle")

        // Si es un enlace real (tiene href válido y no es dropdown/collapse)
        if (href && href !== "#" && !hasToggle && !isDropdown) {
          closeSidebar()
        }
      }
    })
  })

  // Cerrar sidebar al redimensionar a escritorio
  window.addEventListener("resize", () => {
    if (window.innerWidth > 768) {
      closeSidebar()
    }
  })

  // Prevenir que clics dentro del sidebar lo cierren
  if (sidebar) {
    sidebar.addEventListener("click", (e) => {
      e.stopPropagation()
    })
  }

  // Cerrar sidebar si se hace clic fuera de él
  document.addEventListener("click", (e) => {
    if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains("show")) {
      if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
        closeSidebar()
      }
    }
  })
}

/**
 * Inicializa tooltips de Bootstrap
 */
function initializeTooltips() {
  if (typeof bootstrap !== "undefined") {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl))
  }
}

/**
 * Inicializa modales
 */
function initializeModals() {
  // Limpiar modales al cerrar
  document.addEventListener("hidden.bs.modal", (event) => {
    const modal = event.target
    const form = modal.querySelector("form")
    if (form) {
      form.reset()
      clearFormErrors(form)
    }
  })
}

/**
 * Inicializa formularios
 */
function initializeForms() {
  // Validación en tiempo real
  const forms = document.querySelectorAll(".needs-validation")
  forms.forEach((form) => {
    form.addEventListener("submit", (event) => {
      if (!form.checkValidity()) {
        event.preventDefault()
        event.stopPropagation()
      }
      form.classList.add("was-validated")
    })
  })

  // Auto-guardar formularios
  const autoSaveForms = document.querySelectorAll("[data-auto-save]")
  autoSaveForms.forEach((form) => {
    setInterval(() => {
      autoSaveForm(form)
    }, window.IntranetApp.config.autoSaveInterval)
  })
}

/**
 * Inicializa la navegación
 */
function initializeNavigation() {
  // Funcionalidad ya movida a initializeSidebar()
}

/**
 * Muestra notificación toast
 */
function showNotification(message, type = "info", duration = 5000) {
  const toastContainer = getOrCreateToastContainer()

  const toastId = "toast-" + Date.now()
  const toastHtml = `
        <div id="${toastId}" class="toast align-items-center text-white bg-${type} border-0" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `

  toastContainer.insertAdjacentHTML("beforeend", toastHtml)

  const toastElement = document.getElementById(toastId)
  const toast = new bootstrap.Toast(toastElement, { delay: duration })
  toast.show()

  // Remover el elemento después de que se oculte
  toastElement.addEventListener("hidden.bs.toast", () => {
    toastElement.remove()
  })
}

/**
 * Obtiene o crea el contenedor de toasts
 */
function getOrCreateToastContainer() {
  let container = document.querySelector("#toast-container")
  if (!container) {
    container = document.createElement("div")
    container.id = "toast-container"
    container.className = "toast-container position-fixed top-0 end-0 p-3"
    container.style.zIndex = "9999"
    document.body.appendChild(container)
  }
  return container
}

/**
 * Confirma una acción
 */
function confirmAction(message, callback) {
  if (confirm(message)) {
    callback()
  }
}

/**
 * Muestra modal de confirmación
 */
function showConfirmModal(title, message, onConfirm, onCancel = null) {
  const modalHtml = `
        <div class="modal fade" id="confirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">${title}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" id="confirmBtn">Confirmar</button>
                    </div>
                </div>
            </div>
        </div>
    `

  // Remover modal existente si existe
  const existingModal = document.querySelector("#confirmModal")
  if (existingModal) {
    existingModal.remove()
  }

  document.body.insertAdjacentHTML("beforeend", modalHtml)

  const modal = new bootstrap.Modal(document.querySelector("#confirmModal"))

  document.querySelector("#confirmBtn").addEventListener("click", () => {
    modal.hide()
    onConfirm()
  })

  if (onCancel) {
    document.querySelector("#confirmModal").addEventListener("hidden.bs.modal", onCancel)
  }

  modal.show()
}

/**
 * Limpia errores de formulario
 */
function clearFormErrors(form) {
  const errorElements = form.querySelectorAll(".invalid-feedback, .text-danger")
  errorElements.forEach((element) => {
    element.remove()
  })

  const invalidInputs = form.querySelectorAll(".is-invalid")
  invalidInputs.forEach((input) => {
    input.classList.remove("is-invalid")
  })
}

/**
 * Muestra errores de formulario
 */
function showFormErrors(form, errors) {
  clearFormErrors(form)

  Object.keys(errors).forEach((fieldName) => {
    const field = form.querySelector(`[name="${fieldName}"]`)
    if (field) {
      field.classList.add("is-invalid")

      const errorDiv = document.createElement("div")
      errorDiv.className = "invalid-feedback"
      errorDiv.textContent = errors[fieldName]

      field.parentNode.appendChild(errorDiv)
    }
  })
}

/**
 * Auto-guarda un formulario
 */
function autoSaveForm(form) {
  const formData = new FormData(form)
  const data = Object.fromEntries(formData.entries())

  localStorage.setItem(`autosave_${form.id}`, JSON.stringify(data))
}

/**
 * Restaura datos auto-guardados
 */
function restoreAutoSavedData(form) {
  const savedData = localStorage.getItem(`autosave_${form.id}`)
  if (savedData) {
    const data = JSON.parse(savedData)
    Object.keys(data).forEach((key) => {
      const field = form.querySelector(`[name="${key}"]`)
      if (field) {
        field.value = data[key]
      }
    })
  }
}

/**
 * Limpia datos auto-guardados
 */
function clearAutoSavedData(formId) {
  localStorage.removeItem(`autosave_${formId}`)
}

/**
 * Formatea fecha
 */
function formatDate(date, format = "dd/mm/yyyy") {
  if (!(date instanceof Date)) {
    date = new Date(date)
  }

  const day = String(date.getDate()).padStart(2, "0")
  const month = String(date.getMonth() + 1).padStart(2, "0")
  const year = date.getFullYear()

  switch (format) {
    case "dd/mm/yyyy":
      return `${day}/${month}/${year}`
    case "yyyy-mm-dd":
      return `${year}-${month}-${day}`
    default:
      return date.toLocaleDateString()
  }
}

/**
 * Valida email
 */
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

/**
 * Debounce function
 */
function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

/**
 * Throttle function
 */
function throttle(func, limit) {
  let inThrottle
  return function () {
    const args = arguments

    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => (inThrottle = false), limit)
    }
  }
}

// Exportar funciones globales
window.IntranetApp.utils = {
  showNotification,
  confirmAction,
  showConfirmModal,
  clearFormErrors,
  showFormErrors,
  formatDate,
  isValidEmail,
  debounce,
  throttle,
}
