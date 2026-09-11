const wrapper = document.getElementById('wrapper')
const box = document.getElementById('achievement')
const iconEl = document.getElementById('icon')
const titleEl = document.getElementById('title')
const pointsEl = document.getElementById('points')
const amountEl = document.getElementById('amount')

const positions = ['top-left', 'top-center', 'top-right', 'middle-left', 'middle-right', 'bottom-left', 'bottom-center', 'bottom-right']

const icons = {
    trophy: '<path d="M7 4h10v5a5 5 0 0 1-10 0z"/><path d="M7 5.5H4.2v1.8A3.5 3.5 0 0 0 7.7 10.8"/><path d="M17 5.5h2.8v1.8a3.5 3.5 0 0 1-3.5 3.5"/><path d="M12 14v3.5"/><path d="M8.5 20.5h7l-1-3h-5z"/>',
    star: '<path d="M12 3l2.7 5.6 6 .9-4.35 4.3 1.05 6.1L12 17l-5.4 2.9 1.05-6.1L3.3 9.5l6-.9z"/>',
    medal: '<circle cx="12" cy="15" r="5.5"/><path d="M12 12.6l1 2.1 2.3.3-1.7 1.6.4 2.3-2-1.1-2 1.1.4-2.3-1.7-1.6 2.3-.3z"/><path d="M8 9.8L5.5 3h4L11.4 7"/><path d="M16 9.8L18.5 3h-4L12.6 7"/>',
    crown: '<path d="M3 7.5l3.2 3.6L12 4.5l5.8 6.6L21 7.5l-1.8 11H4.8z"/><path d="M4.8 15.2h14.4"/>',
    scooter: '<circle cx="5.4" cy="17.5" r="3.2"/><circle cx="18" cy="17.5" r="3.2"/><path d="M8.6 17.5h6"/><path d="M14.6 17.5L18 4.6"/><path d="M15.2 4.6h6"/>',
    car: '<path d="M3 15.5v-3l2-4.6A2 2 0 0 1 6.9 6.6h10.2a2 2 0 0 1 1.9 1.3l2 4.6v3"/><path d="M3 15.5h18"/><path d="M5 15.5v2.4H8v-2.4"/><path d="M16 15.5v2.4h3v-2.4"/><path d="M5.4 12.2h13.2"/>',
    bike: '<circle cx="5.4" cy="16.8" r="3.6"/><circle cx="18.6" cy="16.8" r="3.6"/><path d="M8.4 16.8l3.6-7.4h4.2"/><path d="M12 9.4L9 5.6H7.2"/><path d="M15.6 9.4l3 7.4"/>',
    plane: '<path d="M10.5 3.4a1.5 1.5 0 0 1 3 0V9l7.5 4.4v2.2l-7.5-2.2v3.9l2.6 1.9v1.4L12 19.8l-4.1 1.8v-1.4l2.6-1.9v-3.9L3 16.6v-2.2L10.5 9z"/>',
    boat: '<path d="M3.4 15.6h17.2l-2.4 4.8H5.8z"/><path d="M5.8 15.6V9.4h12l-3 6.2"/><path d="M11.4 9.4V3.6"/>',
    fish: '<path d="M15.6 12c0 3.2-3.8 5.8-7.2 5.8-2.4 0-4.2-1.1-5.4-2.6 1-.9 1.6-2 1.6-3.2s-.6-2.3-1.6-3.2C4.2 7.3 6 6.2 8.4 6.2c3.4 0 7.2 2.6 7.2 5.8z"/><path d="M15.6 12l5.4-3.6v7.2z"/><circle cx="8.4" cy="10.6" r="0.9"/>',
    skull: '<path d="M5 11.4a7 7 0 0 1 14 0v3.2l-1.6 1.4v2.6H6.6V16L5 14.6z"/><circle cx="9.2" cy="11.4" r="1.9"/><circle cx="14.8" cy="11.4" r="1.9"/><path d="M12 14.4v2.2"/>',
    money: '<rect x="2.6" y="6" width="18.8" height="12" rx="1.6"/><circle cx="12" cy="12" r="3"/><path d="M6 9.6v4.8"/><path d="M18 9.6v4.8"/>',
    heart: '<path d="M12 20.2S3.6 15.4 3.6 9.9a4.4 4.4 0 0 1 8.4-1.8 4.4 4.4 0 0 1 8.4 1.8c0 5.5-8.4 10.3-8.4 10.3z"/>',
    gun: '<path d="M3 8.4h15.6a2.4 2.4 0 0 1 2.4 2.4v2.4h-6l-2.4 3.6H9l-.6-3.6H3z"/><path d="M8.4 16.8v3.6"/><path d="M6 8.4V5.4h4.8"/>',
    wrench: '<path d="M15.3 3.6a5.4 5.4 0 0 0-4.9 7.7L3.6 18.1l2.3 2.3 6.8-6.8a5.4 5.4 0 0 0 7-7l-3.2 3.2-2.8-.6-.6-2.8z"/>',
    pill: '<rect x="2.4" y="8.4" width="19.2" height="7.2" rx="3.6" transform="rotate(-40 12 12)"/><path d="M9 9l6 6"/>',
    flag: '<path d="M5.4 21V3.6"/><path d="M5.4 4.8h12l-2.4 3.6 2.4 3.6h-12z"/>',
    camera: '<rect x="2.6" y="7.2" width="18.8" height="12.6" rx="2"/><circle cx="12" cy="13.5" r="3.6"/><path d="M8.4 7.2l1.4-2.8h4.4l1.4 2.8"/>',
    fire: '<path d="M12 21c3.5 0 6-2.4 6-5.6 0-4.4-4.5-5.8-3.6-11.4-3 1.2-5.1 4.2-5.1 7 0 1.3-.9 1.9-1.5 1.2-.6-.7-.6-1.7-.6-1.7-1.4 1.3-2.2 3.1-2.2 4.9C5 18.6 8.5 21 12 21z"/>',
    key: '<circle cx="7.8" cy="8.4" r="4.2"/><path d="M10.8 11.4L20.4 21"/><path d="M17.4 18l2.2-2.2"/><path d="M14.6 15.2l2.2-2.2"/>'
}

function setIcon(icon) {
    if (icon && (icon.startsWith('http') || icon.startsWith('nui://') || icon.startsWith('data:') || /\.(png|jpe?g|gif|webp|svg)$/i.test(icon))) {
        iconEl.innerHTML = '<img src="' + icon + '">'
        return
    }
    iconEl.innerHTML = '<svg viewBox="0 0 24 24">' + (icons[icon] || icons.trophy) + '</svg>'
}

function setPosition(pos) {
    if (!positions.includes(pos) || wrapper.classList.contains('pos-' + pos)) return

    wrapper.className = 'pos-' + pos

    box.style.transition = 'none'
    void box.offsetWidth
    box.style.transition = ''
}

function show(data) {
    setPosition(data.position)
    if (data.margin !== undefined) wrapper.style.setProperty('--margin', data.margin + 'px')
    if (data.scale) box.style.zoom = data.scale

    titleEl.textContent = data.label || ''
    setIcon(data.icon)

    if (data.points > 0) {
        amountEl.textContent = '+' + data.points
        pointsEl.style.display = ''
    } else {
        pointsEl.style.display = 'none'
    }

    void box.offsetWidth
    box.classList.add('visible')
}

window.addEventListener('message', (e) => {
    const data = e.data

    switch (data.action) {
        case 'show':
            show(data)
            break
        case 'hide':
            box.classList.remove('visible')
            break
    }
})
