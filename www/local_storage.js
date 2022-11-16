// Set local storage
Shiny.addCustomMessageHandler("set_local_storage", function (input) {
  localStorage.setItem(input.id, input.data);
});

// Get local storage
Shiny.addCustomMessageHandler("get_local_storage", function (id) {
  const message = localStorage.getItem(id);
  Shiny.setInputValue("main-local_storage", message, { priority: "event" });
});

// Get all local storage
Shiny.addCustomMessageHandler("get_local_storage_multi", function (ids) {
  const message = ids.map(function (id) {
    const res = localStorage.getItem(id);
    return res ? res : 0;
  });

  Shiny.setInputValue("saved-local_storage_multi", message, {
    priority: "event",
  });
});

// Clear local storage for id
Shiny.addCustomMessageHandler("remove_local_storage", function (id) {
  localStorage.removeItem(id);
});
