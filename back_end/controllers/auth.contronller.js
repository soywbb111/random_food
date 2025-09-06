/** Req/res, call services */
const { registerNewUser, loginUser } = require('../services/auth.service');

exports.register = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'Does not have email/password' });
    await registerNewUser(email, password);
    res.status(201).json({ message: 'Done' });
  } catch (err) {
    res.status(err.status || 500).json({ message: err.message || 'Error' });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'Does not have email/password' });
    const { ok, user } = await loginUser(email, password);
    if (!ok) return res.status(401).json({ message: 'Email/Password is incorrected' });
    res.json({ message: 'Login is succesed', user });
  } catch {
    res.status(500).json({ message: 'Login error' });
  }
};