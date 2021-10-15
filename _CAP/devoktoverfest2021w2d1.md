# devtoberfest 2021 
W2 - SAP CAP - David Kunst
https://github.com/SAP-samples/devtoberfest-2021/blob/main/topics/Week2_Best_Practices/README.md#best-practices-for-cap-nodejs-apps

best practices , nodeJS
https://www.youtube.com/channel/UCFU7a7OMYfcpjtIpu2j47_Q
https://github.com/David-Kunz


CAP nodeJS
* Dependency management
* Error handling
* Transaction handling
* Database pool configuration
* Logging
* Generic handlers
* Environment
* Testing
* REPL

# 1 - dependencies: 
Suddenly my app stopped working in production because of some updates!
(no package-lock.json)
## wrong: 
{
 "dependencies": {
 "@sap/cds": "latest"
 }
}
## fix: 
* package-lock.json -> freeze versions 
* manually update ```npm outdated / update ```
{
 "dependencies": {
 "@sap/cds": "^5.4.0"
 }
}
semantic versioning: major.minor.patch 
^5.4.0 (caret)
~5.4.0 (tilde)

# 2 - error handling
## error: 
Sometimes, my app behaves in a very unexpected way!
```js 
const payCustomers = customers => {
 try {
 customers.forEach(c => { c.payments.paid = true })
 } catch (e) {
 console.error("Some error happened:", e)
 }
}
```
Also programming errors are caught
## fix: 
Do not catch programming errors
They need to be fixed
For unknown programming errors, the app
must crash, fail loudly, then fix
```js 
const payCustomers = customers =>
 customers.forEach(c => {
 if (c.payments) c.payments.paid = true
 })
```
## error 
After some point in time, my app stops working properly.
```js 
app.use((err, req, res, next) => {
 console.error(err)
 res.sendStatus(500) // Internal Server Error
})
``` 
## fix 
Let your app crash when there are unexpected
errors
Restart the app automatically
Do not leave it in a zombie state
There might be side effects
CAP server crashes when there are
programming errors
err instanceof TypeError ||
err instanceof ReferenceError ||
err instanceof SyntaxError ||
err instanceof RangeError ||
err instanceof URIError

## error
There's an error in my app, but I can't find the root cause!
```js 
try {
 mightThrow()
} catch {
 throw
 ```
## fix 
error information lost when throw... 
try {
 mightThrow()
} catch (e) {
 throw Object.assign(
 new Error('Some error happened'),
 { cause: e })
}
There's also a new feature in V8 v9.3:
throw new Error('Some error happened', { cause: e })


# 3 Transaction handling 
## error 
After the first request, my app doesn't respond anymore!

```js 
srv.on('READ', 'Books', req => cds.tx()
 .run(SELECT.from('Books')))
```
// reason: cds.tx() starts a new (unmanaged) transaction
## fix 
Bind your transaction to the request
srv.on('READ', 'Books', req => cds.tx(req)
 .run(SELECT.from('Books')


Our database operations start with BEGIN and
must end with COMMIT/ROLLBACK
In SQLite, there are no parallel transactions
cds.tx(req) automatically performs a
COMMIT once the request is succeeded or
ROLLBACK if it fails

## fix 2: AsyncLocalStorage
srv.on('READ', 'Books', () => SELECT.from('Books'))
Information about the current transaction is
saved in cds.context
It's not a global variable - it's local w.r.t. the
async context

## error 
After the first request to my express
handler, my app doesn't respond anymore!


# 4 - Database pool configuration
## error 
Background database operations
have a strange behavior!
```js 
const backgroundTask = async () => {
 await UPDATE("ReadCounter")
 .set({ count: { "+=": 1 } })
 .where({ ID: 'Books' })
}
srv.on("READ", "Books", (req, next) => {
 backgroundTask() // no await
 return next()
})
```
Race conditions in transaction handling
## fix : cds.spawn 
```js 
const backgroundTask = async () => {
 await UPDATE("ReadCounter")
 .set({ count: { "+=": 1 } })
 .where({ ID: 'Books' })
}
srv.on("READ", "Books", (req, next) => {
 cds.spawn(backgroundTask)
 return next()
})
```
## erro 2 : Some requests fail during high load!
possible reason: Database pool misconfiguration




# 5 Logging
## error: I can't use Kibana to analyze the logs!
console.log("My custom log output")
## fix: LOG with the Kibana formatter
const LOG = cds.log('custom')
LOG.info("My custom log output")
cds.env.features.kibana_formatter

# 6 Generic handlers
## error: 
How can I register generic handlers for all services?
**sol**: Define an own implementation of the app service
```js
{
 "cds": {
 "requires": {
 "app-service": {
 "impl": "lib/MyAppService.js"
 }
 }
 }
}
const cds = require('@sap/cds')
const LOG = cds.log('generic')
class MyAppService extends cds.ApplicationService {
 async init() {
 await super.init()
 this.before('*'
,
'*'
, req => {
 LOG.info('generic before handler is called')
 })
 }
}
module.exports = MyAppService
```
# 7 Environment
# 8 Testing
# 9 REPL

# end 

