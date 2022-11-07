import { Chart } from "../chart.js"

let chart = {
  mounted() {
    let labels = [
      "Day",
      "Week",
      "Month"
    ];

    let data = {
      labels: labels,
      datasets: [{
        label: this.el.dataset.label,
        data: [100, 100, 100],
        backgroundColor: [
          'rgba(201, 203, 207, 0.2)',
          'rgba(7, 89, 133, 0.2)',
          'rgba(30, 64, 175, 0.2)'
        ],
        borderColor: [
          'rgb(201, 203, 207)',
          'rgb(7, 89, 133)',
          'rgb(30, 64, 175)'
        ],
        borderWidth: 2,
        barPercentage: 0.6,
        categoryPercentage: 1
      }]
    };

    let config = {
      type: 'bar',
      data: data,
      options: {
        indexAxis: 'y',
        maintainAspectRatio: false,
        scales: {
          x: {
            beginAtZero: true
          }
        }
      },
    };
    var ctx = this.el.getContext('2d');
    let myChart = new Chart(
      ctx,
      config
    )

    this.handleEvent("points", ({ points }) => {
      myChart.data.datasets[0].data = points
      myChart.update()
    })
  }
}

export default chart;