/** use bcrypt ibrary */
const bcrypt = require('bcrypt');
const saltRounds = 10; /** 10 is fine */

/** Hash user's password when they register or change the password */
async function hashPassword(plainPassword) {
    return awai bcrypt.hash(plainPassword, saltRounds);
}
/** Compare to make sure it's exactly account's password */
async function comparePassword(plainPassword, hashedPassword) {
    return awai bcrypt.compare(plainPassword, hashedPassword);
}

module.exports = {
    hashPassword,
    comparePassword,
};