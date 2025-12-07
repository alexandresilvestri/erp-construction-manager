# Backend - Testing with Vitest and Supertest

## Overview

The backend uses:
- **Vitest**: Fast unit test framework (alternative to Jest)
- **Supertest**: HTTP assertion library for testing Express APIs

## Running Tests

```bash
# Run all tests once
npm test

# Run tests in watch mode (re-runs on file changes)
npm run test:watch

# Run tests with coverage report
npm run test:coverage
```

## Writing Tests

Tests use Vitest's API which is compatible with Jest. Here's an example:

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import app from './app';

describe('Your Feature', () => {
  it('should do something', async () => {
    const response = await request(app)
      .get('/api/endpoint')
      .expect(200);

    expect(response.body).toHaveProperty('data');
  });
});
```

## Vitest vs Jest

**Why Vitest?**
- ⚡ **Faster**: Uses Vite's transformation pipeline
- 🔄 **Better HMR**: Hot Module Replacement for tests
- 📦 **Smaller**: Less dependencies
- 🎯 **ESM First**: Native ESM support
- ✅ **Compatible**: Jest-compatible API

## Supertest Basics

```typescript
// GET request
await request(app).get('/api/users');

// POST request with body
await request(app)
  .post('/api/users')
  .send({ name: 'John' })
  .expect(201);

// With headers
await request(app)
  .get('/api/protected')
  .set('Authorization', 'Bearer token')
  .expect(200);

// Testing response
const response = await request(app).get('/api/users');
expect(response.status).toBe(200);
expect(response.body).toHaveLength(5);
```

## Test Structure

```
src/
├── app.ts              # Express app (exported for testing)
├── server.ts           # Server startup (not imported in tests)
├── index.ts            # Entry point
├── app.test.ts         # App-level tests
└── features/
    ├── users/
    │   ├── users.controller.ts
    │   ├── users.service.ts
    │   └── users.test.ts
    └── projects/
        ├── projects.controller.ts
        ├── projects.service.ts
        └── projects.test.ts
```

## Configuration

The test configuration is in `vitest.config.ts`:

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,           // Use global test functions
    environment: 'node',     // Node.js environment
    coverage: {
      provider: 'v8',        // Coverage provider
      reporter: ['text', 'json', 'html'],
    },
  },
});
```

## Example: Testing API Endpoints

```typescript
import { describe, it, expect } from 'vitest';
import request from 'supertest';
import app from './app';

describe('API Endpoints', () => {
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'ok');
      expect(response.body).toHaveProperty('timestamp');
    });
  });

  describe('POST /api/users', () => {
    it('should create a user', async () => {
      const newUser = {
        name: 'John Doe',
        email: 'john@example.com'
      };

      const response = await request(app)
        .post('/api/users')
        .send(newUser)
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.name).toBe(newUser.name);
    });

    it('should validate required fields', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({})
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });
  });
});
```

## Example: Testing with Database

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import app from './app';
import { db } from './database';

describe('Users API', () => {
  beforeEach(async () => {
    // Setup test database
    await db.migrate.latest();
  });

  afterEach(async () => {
    // Cleanup
    await db.migrate.rollback();
  });

  it('should create a user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John Doe', email: 'john@example.com' })
      .expect(201);

    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('John Doe');
  });

  it('should list all users', async () => {
    // Create test data
    await db('users').insert([
      { name: 'User 1', email: 'user1@example.com' },
      { name: 'User 2', email: 'user2@example.com' },
    ]);

    const response = await request(app)
      .get('/api/users')
      .expect(200);

    expect(response.body).toHaveLength(2);
  });
});
```

## Mocking with Vitest

### Mock a Module

```typescript
import { vi } from 'vitest';

vi.mock('./database', () => ({
  db: {
    query: vi.fn(() => Promise.resolve([{ id: 1 }])),
  },
}));
```

### Mock a Function

```typescript
const mockFn = vi.fn();
mockFn.mockReturnValue('mocked value');
mockFn.mockResolvedValue('async mocked value');

expect(mockFn).toHaveBeenCalled();
expect(mockFn).toHaveBeenCalledWith('arg');
```

### Spy on a Function

```typescript
const spy = vi.spyOn(object, 'method');
spy.mockReturnValue('mocked');

expect(spy).toHaveBeenCalledWith('arg');
spy.mockRestore();
```

### Mock Environment Variables

```typescript
import { vi } from 'vitest';

describe('Config', () => {
  const originalEnv = process.env;

  beforeEach(() => {
    vi.resetModules();
    process.env = { ...originalEnv };
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  it('should use test database', () => {
    process.env.DB_NAME = 'test_db';
    // your test here
  });
});
```

## Coverage Reports

After running `npm run test:coverage`, view the report:

```bash
# Open HTML report
open coverage/index.html      # macOS
xdg-open coverage/index.html  # Linux
start coverage/index.html      # Windows
```

Coverage reports show:
- **Statement coverage**: % of statements executed
- **Branch coverage**: % of conditional branches tested
- **Function coverage**: % of functions called
- **Line coverage**: % of lines executed

## Best Practices

### 1. Separate App from Server

Export your Express app separately from the server startup:

```typescript
// app.ts - Export the app
export default app;

// server.ts - Start the server
import app from './app';
app.listen(PORT);

// index.ts - Entry point
import './server';
```

### 2. Use Descriptive Test Names

```typescript
// ❌ Bad
it('test 1', () => {});

// ✅ Good
it('should return 404 when user is not found', () => {});
```

### 3. Follow AAA Pattern

```typescript
it('should create a user', async () => {
  // Arrange
  const userData = { name: 'John', email: 'john@example.com' };

  // Act
  const response = await request(app)
    .post('/api/users')
    .send(userData);

  // Assert
  expect(response.status).toBe(201);
  expect(response.body.name).toBe('John');
});
```

### 4. Test Edge Cases

```typescript
describe('User validation', () => {
  it('should accept valid email', async () => {
    // test valid case
  });

  it('should reject invalid email format', async () => {
    // test invalid case
  });

  it('should reject empty email', async () => {
    // test edge case
  });

  it('should reject duplicate email', async () => {
    // test edge case
  });
});
```

### 5. Keep Tests Independent

```typescript
// ❌ Bad - Tests depend on each other
let userId;
it('should create user', async () => {
  const res = await request(app).post('/users').send({});
  userId = res.body.id; // Other tests depend on this
});

// ✅ Good - Each test is independent
it('should create user', async () => {
  const res = await request(app).post('/users').send({});
  expect(res.body).toHaveProperty('id');
});

it('should get user by id', async () => {
  // Create user in this test
  const createRes = await request(app).post('/users').send({});
  const userId = createRes.body.id;

  // Now test getting the user
  const getRes = await request(app).get(`/users/${userId}`);
  expect(getRes.status).toBe(200);
});
```

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - uses: actions/setup-node@v3
        with:
          node-version: 20
          cache: 'npm'

      - run: npm ci

      - run: npm test

      - run: npm run test:coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
```

## Running Tests in Docker

```bash
# Run tests inside the backend container
docker compose exec backend npm test

# Run tests with coverage
docker compose exec backend npm run test:coverage

# Run tests in watch mode
docker compose exec backend npm run test:watch
```

## Troubleshooting

### Tests Not Running

```bash
# Clear Vitest cache
rm -rf node_modules/.vitest

# Reinstall dependencies
npm install
```

### Port Already in Use

Make sure you're testing the app instance, not starting a server:

```typescript
// ✅ Good - No server started
import app from './app';
await request(app).get('/');

// ❌ Bad - Server already running
import './server'; // This starts the server!
```

### Database Connection Issues

Use a separate test database:

```typescript
const dbConfig = process.env.NODE_ENV === 'test'
  ? { database: 'test_db' }
  : { database: 'dev_db' };
```

## Additional Resources

- [Vitest Documentation](https://vitest.dev/)
- [Supertest Documentation](https://github.com/ladjs/supertest)
- [Testing Best Practices](https://testingjavascript.com/)
