const ctx = document.getElementById('barChart').getContext('2d');
let chart; // Reference to the Chart.js instance
let currentData = [];

function fetchCSV() {
    fetch('sample.csv')
        .then(response => response.text())
        .then(csvData => {
            // Parse CSV
            const parsed = Papa.parse(csvData, { header: true });
            const newData = parsed.data.filter(row => row.Date); // Filter out empty rows

            // Check if data has changed
            if (JSON.stringify(newData) !== JSON.stringify(currentData)) {
                currentData = newData;
                updateChart(newData);
            }
        })
        .catch(error => console.error('Error fetching CSV:', error));
}

function updateChart(data) {
    const dates = data.map(row => row.Date);
    const sales = data.map(row => parseFloat(row.Sales) || 0);
    const profits = data.map(row => parseFloat(row.Profit) || 0);

    if (chart) {
        // Update existing chart
        chart.data.labels = dates;
        chart.data.datasets[0].data = sales;
        chart.data.datasets[1].data = profits;
        chart.update();
    } else {
        // Create new chart
        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dates,
                datasets: [
                    {
                        label: 'Sales',
                        data: sales,
                        backgroundColor: 'rgba(75, 192, 192, 0.6)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1,
                    },
                    {
                        label: 'Profit',
                        data: profits,
                        backgroundColor: 'rgba(255, 99, 132, 0.6)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 1,
                    },
                ],
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: { enabled: true },
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        title: { display: true, text: 'Date' },
                    },
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Values' },
                    },
                },
            },
        });
    }
}

// Polling to fetch CSV periodically
setInterval(fetchCSV, 5000); // Fetch every 5 seconds

// Initial fetch
fetchCSV();
