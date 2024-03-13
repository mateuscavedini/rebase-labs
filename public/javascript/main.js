const pageHeading = document.getElementById("page-heading")
const tableHeaderRow = document.getElementById("table-header-row");
const tableBody = document.getElementById("table-body");

const setupTableHeaders = (headers) => {
  headers.forEach((header) => {
    const headerCell = document.createElement("th");

    headerCell.textContent = header;
    tableHeaderRow.appendChild(headerCell);
  });
};

const setupTableBodyRow = (values) => {
  const bodyRow = document.createElement("tr");

  values.forEach((value) => {
    const bodyCell = document.createElement("td");

    bodyCell.textContent = value;
    bodyRow.appendChild(bodyCell);
  });

  tableBody.appendChild(bodyRow)
};

const resetPage = () => {
  tableHeaderRow.replaceChildren()
  tableBody.replaceChildren()
}

const handleExamsListing = () => {
  resetPage()
  pageHeading.textContent = "Exames Registrados"

  fetch("/exams")
    .then((response) => response.json())
    .then((exams) => {
      const tableHeaders = [
        "Token Exame",
        "Data Exame",
        "Paciente",
        "CPF",
        "Médico",
        "CRM",
      ];

      setupTableHeaders(tableHeaders);

      exams.forEach((exam) => {
        const rowValues = [
          exam.token,
          exam.date,
          exam.patient.name,
          exam.patient.cpf,
          exam.doctor.name,
          `${exam.doctor.crm}-${exam.doctor.crm_state}`,
        ];

        setupTableBodyRow(rowValues);
      });
    })
    .catch((err) => console.log(err));
};

handleExamsListing();
