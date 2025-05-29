const mean = data => data.reduce((a, b) => a + b, 0) / data.length;

const variance = data => {
  const m = mean(data);
  return data.reduce((sum, x) => sum + (x - m) ** 2, 0) / data.length;
};

const filter = (data, condition) => data.filter(condition);

const select = (data, keys) => data.map(row => {
  const selected = {};
  keys.forEach(key => selected[key] = row[key]);
  return selected;
});

module.exports = { mean, variance, filter, select };
