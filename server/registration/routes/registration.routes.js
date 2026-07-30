const express = require('express');
const controller = require('../controllers/registration.controller');

const router = express.Router();

router.post('/agent/register', controller.registerAgent);

module.exports = router;