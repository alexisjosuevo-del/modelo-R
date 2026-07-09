// Configuración global de Chart.js para diseño oscuro/premium
Chart.defaults.color = '#cbd5e1';
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15, 23, 42, 0.9)';
Chart.defaults.plugins.tooltip.titleColor = '#60a5fa';
Chart.defaults.plugins.tooltip.padding = 10;
Chart.defaults.plugins.tooltip.borderColor = 'rgba(96, 165, 250, 0.3)';
Chart.defaults.plugins.tooltip.borderWidth = 1;

// Datos simulados (32 entidades)
const entidades = ["Ags","BC","BCS","Camp","Coah","Col","Chis","Chih","CDMX","Dgo","Gto","Gro","Hgo","Jal","Edomex","Mich","Mor","Nay","NL","Oax","Pue","Qro","QRoo","SLP","Sin","Son","Tab","Tamps","Tlax","Ver","Yuc","Zac"];

// Generar datos aleatorios con cierta correlación para simular el modelo
const generateData = () => {
    let desempleo = [];
    let efectividad = [];
    let incidencia = [];
    let residuos = [];

    for(let i=0; i<32; i++) {
        let des = (Math.random() * 4) + 2; 
        let efec = (Math.random() * 40) + 30; 
        
        // Ecuación: 15230 + 845*des - 125*efec + ruido
        let ruido = (Math.random() * 8000) - 4000; 
        let inc = 15230.45 + (845.6 * des) - (125.3 * efec) + ruido;
        
        desempleo.push(des);
        efectividad.push(efec);
        incidencia.push(inc);
        residuos.push(ruido); 
    }
    return {desempleo, efectividad, incidencia, residuos};
};

const data = generateData();

// Textos de explicación teórica aplicados
const theoryTexts = {
    desempleo: {
        title: "Relación: Incidencia vs Desempleo",
        body: "<strong>Interpretación Teórica:</strong> En este gráfico de dispersión, cada punto representa una entidad federativa. La línea roja muestra la <em>recta de regresión estimada</em>, que aísla el efecto del desempleo manteniendo constante la efectividad policial (ceteris paribus).<br><br><strong>Aplicación del Modelo:</strong> El coeficiente de 845.60 indica una relación positiva y estadísticamente significativa (p < 0.01). Esto sugiere que, en promedio, por cada incremento de un punto porcentual en la tasa de desempleo, la incidencia delictiva aumenta en aproximadamente 845 delitos por cada 100,000 habitantes. Esto respalda la teoría económica del crimen, donde menores oportunidades en el mercado laboral formal (desempleo) aumentan los incentivos para participar en actividades ilícitas."
    },
    efectividad: {
        title: "Relación: Incidencia vs Efectividad Policial",
        body: "<strong>Interpretación Teórica:</strong> Este gráfico ilustra la relación parcial entre la percepción de efectividad policial y el crimen. Al igual que en el gráfico anterior, la línea roja representa el efecto marginal estimado por nuestro modelo multivariado.<br><br><strong>Aplicación del Modelo:</strong> El coeficiente negativo de -125.30 (significativo al 5%) indica un efecto disuasorio de las instituciones de seguridad. Por cada aumento de 1% en la población que percibe como efectiva a la policía, la incidencia delictiva disminuye en 125 puntos. Esto corrobora empíricamente que la legitimidad e institucionalidad (efectividad policial percibida) incrementan los costos esperados de delinquir (mayor probabilidad de ser atrapado y castigado), reduciendo así la oferta delictiva."
    },
    residuos: {
        title: "Distribución de Residuos (Normalidad)",
        body: "<strong>Interpretación Teórica:</strong> Este histograma muestra la distribución empírica de los residuos (la diferencia entre el nivel de delincuencia observado y el que nuestro modelo predice: <em>u = Y - Ŷ</em>).<br><br><strong>Aplicación del Modelo:</strong> Uno de los supuestos clásicos de la regresión lineal por Mínimos Cuadrados Ordinarios (MCO) es que los errores se distribuyen normalmente, con media cero. Visualmente, buscamos que el histograma se asemeje a una 'campana de Gauss'. Si esta prueba (junto con Shapiro-Wilk y Jarque-Bera) pasa, podemos confiar en que las pruebas de hipótesis ('p-values', pruebas T y F) son válidas y robustas, permitiéndonos asegurar estadísticamente nuestras conclusiones sobre el desempleo y la policía."
    }
};

// Funciones del Modal
const modal = document.getElementById("explanationModal");
const closeBtn = document.getElementsByClassName("close-btn")[0];
const modalTitle = document.getElementById("modalTitle");
const modalBody = document.getElementById("modalBody");

const openModal = (key) => {
    modalTitle.innerHTML = theoryTexts[key].title;
    modalBody.innerHTML = theoryTexts[key].body;
    modal.style.display = "block";
};

closeBtn.onclick = () => { modal.style.display = "none"; };
window.onclick = (event) => { if (event.target == modal) { modal.style.display = "none"; } };


// Preparar datos para Scatter Plots
const scatterDesempleo = data.desempleo.map((x, i) => ({x: x, y: data.incidencia[i]}));
const scatterEfectividad = data.efectividad.map((x, i) => ({x: x, y: data.incidencia[i]}));

// Gráfico 1: Incidencia vs Desempleo
const ctxDesempleo = document.getElementById('chartDesempleo').getContext('2d');
new Chart(ctxDesempleo, {
    type: 'scatter',
    data: {
        datasets: [{
            label: 'Entidades (Observaciones)',
            data: scatterDesempleo,
            backgroundColor: '#3b82f6',
            borderColor: '#60a5fa',
            pointRadius: 6,
            pointHoverRadius: 8
        },
        {
            label: 'Línea de Tendencia',
            data: [
                {x: 2, y: 15230 + (845*2) - (125*50)}, 
                {x: 6, y: 15230 + (845*6) - (125*50)}
            ],
            type: 'line',
            borderColor: '#ef4444',
            borderWidth: 2,
            pointRadius: 0,
            fill: false
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        onClick: (e) => { openModal('desempleo'); },
        scales: {
            x: { title: { display: true, text: 'Tasa de Desempleo (%)' } },
            y: { title: { display: true, text: 'Incidencia Delictiva' } }
        }
    }
});

// Gráfico 2: Incidencia vs Efectividad Policial
const ctxEfectividad = document.getElementById('chartEfectividad').getContext('2d');
new Chart(ctxEfectividad, {
    type: 'scatter',
    data: {
        datasets: [{
            label: 'Entidades',
            data: scatterEfectividad,
            backgroundColor: '#8b5cf6',
            borderColor: '#a78bfa',
            pointRadius: 6,
            pointHoverRadius: 8
        },
        {
            label: 'Línea de Tendencia',
            data: [
                {x: 30, y: 15230 + (845*4) - (125*30)}, 
                {x: 70, y: 15230 + (845*4) - (125*70)}
            ],
            type: 'line',
            borderColor: '#ef4444',
            borderWidth: 2,
            pointRadius: 0,
            fill: false
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        onClick: (e) => { openModal('efectividad'); },
        scales: {
            x: { title: { display: true, text: 'Efectividad Policial (%)' } },
            y: { title: { display: true, text: 'Incidencia Delictiva' } }
        }
    }
});

// Gráfico 3: Histograma de Residuos
const ctxResiduos = document.getElementById('chartResiduos').getContext('2d');
const bins = 10;
const minR = Math.min(...data.residuos);
const maxR = Math.max(...data.residuos);
const binWidth = (maxR - minR) / bins;

let histogramData = new Array(bins).fill(0);
let labels = [];

for(let i=0; i<bins; i++) {
    labels.push(Math.round(minR + (i * binWidth)).toString());
}

data.residuos.forEach(r => {
    let binIndex = Math.floor((r - minR) / binWidth);
    if(binIndex === bins) binIndex--; 
    histogramData[binIndex]++;
});

new Chart(ctxResiduos, {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [{
            label: 'Frecuencia de Residuos',
            data: histogramData,
            backgroundColor: 'rgba(6, 182, 212, 0.6)',
            borderColor: '#06b6d4',
            borderWidth: 1,
            borderRadius: 4
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        onClick: (e) => { openModal('residuos'); },
        scales: {
            x: { 
                title: { display: true, text: 'Valor del Residuo' },
                grid: { display: false }
            },
            y: { 
                title: { display: true, text: 'Frecuencia' },
                beginAtZero: true
            }
        },
        plugins: {
            title: {
                display: true,
                text: 'Distribución (Comprobación de Normalidad)'
            }
        }
    }
});
