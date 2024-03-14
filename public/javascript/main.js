const pageHeading = document.getElementById("page-heading");
const tableHeaderRow = document.getElementById("table-header-row");
const tableBody = document.getElementById("table-body");
const backButton = document.getElementById("back-btn");
const searchButton = document.getElementById("search-btn");
const searchInput = document.getElementById("token-input");
const importButton = document.getElementById("import-btn");
const importInput = document.getElementById("import-input");

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

  tableBody.appendChild(bodyRow);
};

const resetPage = () => {
  tableHeaderRow.replaceChildren();
  tableBody.replaceChildren();
  backButton.classList.add("not-displayed");
};

const handleExamsListing = () => {
  resetPage();
  pageHeading.textContent = "Exames Registrados";

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
    .catch((err) => console.log(err))
    .finally(() => (searchInput.value = ""));
};

const handleSearchFormSubmit = (e) => {
  e.preventDefault();
  const token = searchInput.value ? searchInput.value.toUpperCase() : null;

  fetch(`/exams/${token}`)
    .then((response) => response.json())
    .then((data) => {
      resetPage();
      pageHeading.textContent = `Resultado por: ${token}`;

      if (data.errors) {
        window.alert(data.errors);
        handleExamsListing();
        return;
      }

      const tableHeaders = ["Tipo", "Limites", "Resultado"];

      setupTableHeaders(tableHeaders);

      data.tests.forEach((test) => {
        const rowValues = [test.type, test.limits, test.result];

        setupTableBodyRow(rowValues);
      });

      backButton.classList.remove("not-displayed");
    })
    .catch((err) => console.log(err));
};

const handleImportFormSubmit = (e) => {
  e.preventDefault();
  const file = importInput.files[0];
  const formData = new FormData();
  formData.append("file", file);

  fetch("/upload", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.errors) {
        window.alert(windowText);
        handleExamsListing();
        return;
      }

      window.alert(data.message);
      location.reload();
    })
    .catch((err) => console.log(err));
};

searchButton.addEventListener("click", (e) => handleSearchFormSubmit(e));
importButton.addEventListener("click", (e) => handleImportFormSubmit(e));
backButton.addEventListener("click", handleExamsListing);
handleExamsListing();
