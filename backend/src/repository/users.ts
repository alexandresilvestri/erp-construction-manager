//import type { User } from '../model/users'
// import { db } from '../database/db'

/* 
class userRepository {
  async saveUser(user: User): Promise<void> {
    const existingUser = await this.findById(user.id)

    if (existingUser) {
      await db('users').where({ id: user.id }).update(this.userToTableRow(user))

      return
    }

    try {
      await db('users').insert(this.userToTableRow(user))
    } catch (err) {
      if (
        err instanceof Error &&
        err.message.includes(
          'insert into "users" ("email", "id", "password_hash", "phone_number", "username") values ($1, $2, $3, $4, $5) - duplicate key value violates unique constraint "users_email_unique"'
        )
      ) {
        throw new Error('Email already exists')
      }

      throw err

    }
    
    return
  }

  async findByEmail(email: string): Promise<User | null> {
    const user = await db('users').where({ email }).first()
    
  }
}
*/
