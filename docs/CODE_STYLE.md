# 📝 Code Style Guide

> **Code Standards and Best Practices for Construction Manager ERP**

This document defines the coding standards and best practices for this project. Following these guidelines ensures code consistency, readability, and maintainability across the entire codebase.

## 🎯 General Principles

- **Write clean, readable code** - Code is read more often than it's written
- **Keep it simple** - Avoid over-engineering and unnecessary complexity
- **Be consistent** - Follow the established patterns in the codebase
- **Test your code** - Write tests for new features and bug fixes
- **Document when necessary** - Add comments for complex logic, not obvious code

## 🔧 Code Formatting

### Prettier Configuration

We use Prettier for automatic code formatting with the following rules:

```json
{
  "semi": false,
  "singleQuote": false,
  "trailingComma": "es5",
  "tabWidth": 2,
  "printWidth": 80,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

**Key Rules:**
- ❌ **No semicolons** at the end of statements
- ✅ **Double quotes** for strings (not single quotes)
- 📏 **2 spaces** for indentation (no tabs)
- 📐 **80 characters** maximum line length
- 🔄 **Trailing commas** in ES5-compatible locations
- ➡️ **Arrow function parentheses** always required

### Running Prettier

**Backend:**
```bash
docker compose exec backend npm run format        # Format all files
docker compose exec backend npm run format:check  # Check only
```

**Frontend:**
```bash
docker compose exec frontend npm run format       # Format all files
docker compose exec frontend npm run format:check # Check only
```

## 📦 TypeScript Standards

### Naming Conventions

```typescript
// ✅ GOOD - Use PascalCase for classes and interfaces
class UserService {}
interface UserData {}
type RequestStatus = "pending" | "success" | "error"

// ✅ GOOD - Use camelCase for variables, functions, and methods
const userName = "John"
function getUserById(id: string) {}
const handleSubmit = () => {}

// ✅ GOOD - Use UPPER_SNAKE_CASE for constants
const MAX_RETRY_ATTEMPTS = 3
const API_BASE_URL = "https://api.example.com"

// ✅ GOOD - Use descriptive names
const isAuthenticated = true
const hasPermission = false

// ❌ BAD - Avoid single letter names (except for loops)
const u = "John" // Bad
const x = getUserData() // Bad
```

### Type Definitions

```typescript
// ✅ GOOD - Always define types explicitly
interface User {
  id: string
  name: string
  email: string
  createdAt: Date
}

function getUser(id: string): Promise<User> {
  // implementation
}

// ✅ GOOD - Use type inference when obvious
const count = 0 // Type inferred as number
const items = [] // Define type if not immediately populated
const users: User[] = []

// ❌ BAD - Avoid 'any' type
function processData(data: any) {} // Bad

// ✅ GOOD - Use 'unknown' or specific types
function processData(data: unknown) {}
```

### Function Guidelines

```typescript
// ✅ GOOD - Keep functions small and focused
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0)
}

// ✅ GOOD - Use arrow functions for callbacks
const numbers = [1, 2, 3]
const doubled = numbers.map((n) => n * 2)

// ✅ GOOD - Destructure parameters when appropriate
function createUser({ name, email }: { name: string; email: string }) {
  // implementation
}

// ❌ BAD - Avoid functions with too many parameters
function createUser(name, email, age, address, phone, role) {} // Bad

// ✅ GOOD - Use object parameter instead
function createUser(userData: UserCreateInput) {}
```

### Async/Await

```typescript
// ✅ GOOD - Use async/await instead of promises
async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`)
  const data = await response.json()
  return data
}

// ✅ GOOD - Handle errors properly
async function saveUser(user: User): Promise<void> {
  try {
    await database.users.insert(user)
  } catch (error) {
    logger.error("Failed to save user", error)
    throw new DatabaseError("Could not save user")
  }
}

// ❌ BAD - Don't mix async/await with .then()
async function badExample() {
  await fetch("/api/data").then((res) => res.json()) // Inconsistent
}
```

## 🎨 React/Frontend Standards

### Component Structure

```typescript
// ✅ GOOD - Functional components with TypeScript
interface UserCardProps {
  user: User
  onEdit?: (user: User) => void
}

function UserCard({ user, onEdit }: UserCardProps) {
  const [isEditing, setIsEditing] = useState(false)

  const handleEdit = () => {
    setIsEditing(true)
    onEdit?.(user)
  }

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <button onClick={handleEdit}>Edit</button>
    </div>
  )
}

export default UserCard
```

### Hooks

```typescript
// ✅ GOOD - Custom hooks start with 'use'
function useAuth() {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchCurrentUser().then(setUser).finally(() => setLoading(false))
  }, [])

  return { user, loading }
}

// ✅ GOOD - Extract complex logic into custom hooks
function useFormValidation(schema: ValidationSchema) {
  // validation logic
}
```

### Event Handlers

```typescript
// ✅ GOOD - Prefix event handlers with 'handle'
function LoginForm() {
  const handleSubmit = (event: FormEvent) => {
    event.preventDefault()
    // submit logic
  }

  const handleInputChange = (event: ChangeEvent<HTMLInputElement>) => {
    // input change logic
  }

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleInputChange} />
    </form>
  )
}
```

## 🔙 Backend/API Standards

### Route Handlers

```typescript
// ✅ GOOD - Use async/await with proper error handling
app.get("/api/users/:id", async (req, res, next) => {
  try {
    const user = await userService.findById(req.params.id)

    if (!user) {
      return res.status(404).json({ error: "User not found" })
    }

    res.json({ data: user })
  } catch (error) {
    next(error)
  }
})

// ✅ GOOD - Validate input
app.post("/api/users", async (req, res, next) => {
  try {
    const validated = userSchema.parse(req.body)
    const user = await userService.create(validated)
    res.status(201).json({ data: user })
  } catch (error) {
    next(error)
  }
})
```

### Service Layer

```typescript
// ✅ GOOD - Separate business logic into services
class UserService {
  constructor(private db: Database) {}

  async findById(id: string): Promise<User | null> {
    return this.db.users.findOne({ id })
  }

  async create(data: UserCreateInput): Promise<User> {
    const hashedPassword = await this.hashPassword(data.password)
    return this.db.users.insert({
      ...data,
      password: hashedPassword,
      createdAt: new Date(),
    })
  }

  private async hashPassword(password: string): Promise<string> {
    return argon2.hash(password)
  }
}
```

### Database Queries

```typescript
// ✅ GOOD - Use Knex query builder
async function getUserProjects(userId: string) {
  return db("projects")
    .select("*")
    .where({ user_id: userId })
    .orderBy("created_at", "desc")
}

// ✅ GOOD - Use transactions for multiple operations
async function transferFunds(fromId: string, toId: string, amount: number) {
  return db.transaction(async (trx) => {
    await trx("accounts").where({ id: fromId }).decrement("balance", amount)
    await trx("accounts").where({ id: toId }).increment("balance", amount)
  })
}
```

## 📁 File Organization

### File Naming

```
✅ GOOD
components/UserCard.tsx
services/userService.ts
utils/formatDate.ts
hooks/useAuth.ts
types/user.ts

❌ BAD
components/user-card.tsx    // Use PascalCase for components
services/UserService.ts     // Use camelCase for non-components
utils/format_date.ts        // Use camelCase, not snake_case
```

### Import Order

```typescript
// ✅ GOOD - Organize imports logically
// 1. External dependencies
import React, { useState, useEffect } from "react"
import { useNavigate } from "react-router-dom"

// 2. Internal modules
import { userService } from "@/services/userService"
import { formatDate } from "@/utils/formatDate"

// 3. Types
import type { User } from "@/types/user"

// 4. Styles (if applicable)
import "./UserCard.css"
```

## 🧪 Testing Standards

### Test Structure

```typescript
// ✅ GOOD - Descriptive test names
describe("UserService", () => {
  describe("findById", () => {
    it("should return user when found", async () => {
      const user = await userService.findById("123")
      expect(user).toBeDefined()
      expect(user?.id).toBe("123")
    })

    it("should return null when user not found", async () => {
      const user = await userService.findById("nonexistent")
      expect(user).toBeNull()
    })

    it("should throw error when database is unavailable", async () => {
      mockDb.throwError()
      await expect(userService.findById("123")).rejects.toThrow()
    })
  })
})
```

## 🚫 Common Pitfalls to Avoid

```typescript
// ❌ BAD - Don't use var
var count = 0

// ✅ GOOD - Use const or let
const count = 0
let index = 0

// ❌ BAD - Don't mutate function parameters
function addItem(items: Item[], item: Item) {
  items.push(item) // Mutates original array
  return items
}

// ✅ GOOD - Return new values
function addItem(items: Item[], item: Item): Item[] {
  return [...items, item]
}

// ❌ BAD - Don't ignore errors
fetch("/api/data").then((res) => res.json())

// ✅ GOOD - Handle errors
fetch("/api/data")
  .then((res) => res.json())
  .catch((error) => console.error("Failed to fetch", error))

// ❌ BAD - Don't use magic numbers
if (user.role === 1) {}

// ✅ GOOD - Use constants
const USER_ROLE_ADMIN = 1
if (user.role === USER_ROLE_ADMIN) {}

// Better: Use enums or string literals
type UserRole = "admin" | "user" | "guest"
```

## 📚 Additional Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Prettier Documentation](https://prettier.io/docs/)
- [ESLint Rules](https://eslint.org/docs/rules/)

## ✅ Pre-commit Checklist

Before committing your code:

- [ ] Run Prettier to format code
- [ ] Run ESLint to check for issues
- [ ] Run tests and ensure they pass
- [ ] Remove console.logs and debug code
- [ ] Update documentation if needed
- [ ] Test your changes locally

---

**Remember:** These are guidelines, not rigid rules. Use your best judgment, and when in doubt, prioritize code readability and maintainability.
