table.insert(props, {
  Name = "Debug Print",
  Type = "enum",
  Choices = {"None", "Tx/Rx", "Tx", "Rx", "Function Calls", "All"},
  Value = "None"
})
table.insert(props, {
  Name = "Number of Presets",
  Type = "integer",
  Min = 2,
  Max = 50,
  Value = 10,
})